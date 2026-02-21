using Microsoft.AspNetCore.Mvc;
using DevopsStack.API.Models;

namespace DevopsStack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CIPipelineController : ControllerBase
    {
        [HttpGet("info")]
        public IActionResult GetInfo()
        {
            var response = new InfoResponse
            {
                Application = "DevOpsStack CI/CD Demo",
                Version = "1.0.0",
                Status = "Running",
                Framework = "ASP.NET Core 8",
                Timestamp = DateTimeOffset.UtcNow
            };
            return Ok(response);
        }

        [HttpPost("build-status")]
        public IActionResult BuildStatus([FromBody] BuildRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.ProjectName))
            {
                return BadRequest("ProjectName is required");
            }

            var response = new BuildStatusResponse
            {
                Success = true,
                Project = request.ProjectName,
                Stage = "CI Pipeline Complete",
                Steps = new[] { "Restore", "Build", "Test", "Ready for Deployment" }
            };
            return Ok(response);
        }
    }

    public class BuildRequest
    {
        public string ProjectName { get; set; } = string.Empty;
    }
}
