var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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

app.MapGet("/test-deploy", () => "Deployment Updated Successfully!");

app.Run();

public partial class Program { }
