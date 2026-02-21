using Microsoft.EntityFrameworkCore;
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add Database Context
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// 1. MUST ADD THESE to serve verify.html from wwwroot
app.UseDefaultFiles(); 
app.UseStaticFiles(); 

// 2. Swagger configuration (keep it outside the IF block to test)
app.UseSwagger();
app.UseSwaggerUI(c => {
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "V1");
    // If you want swagger at the root (http://localhost:8082/), uncomment:
    // c.RoutePrefix = string.Empty; 
});

// app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.MapGet("/test-deploy", () => "CI/CD Pipeline is working! Hello from GitHub!");

// Helper endpoint to check DB Configuration
app.MapGet("/db-check", (IConfiguration config) => {
    var conn = config.GetConnectionString("DefaultConnection");
    return string.IsNullOrEmpty(conn) ? "No DB Connection Configured" : $"Targeting DB: {conn}";
});

// Simple API to read/write data from SQL Server
app.MapGet("/api/sql-test", async (AppDbContext db) => {
    // Create DB if not exists (for testing only)
    await db.Database.EnsureCreatedAsync();

    // Seed a record if empty
    if (!await db.PipelineLogs.AnyAsync())
    {
        db.PipelineLogs.Add(new PipelineLog { Message = "First Log from Pipeline", CreatedAt = DateTime.UtcNow });
        await db.SaveChangesAsync();
    }

    return await db.PipelineLogs.ToListAsync();
});

app.Run();

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
    public DbSet<PipelineLog> PipelineLogs { get; set; }
}

public class PipelineLog
{
    public int Id { get; set; }
    public string Message { get; set; }
    public DateTime CreatedAt { get; set; }
}

public partial class Program { }
