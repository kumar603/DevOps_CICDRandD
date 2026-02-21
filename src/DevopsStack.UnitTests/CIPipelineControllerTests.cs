using Xunit;
using DevopsStack.API.Controllers;
using Microsoft.AspNetCore.Mvc;
using DevopsStack.API.Models;

namespace DevopsStack.UnitTests
{
    public class CIPipelineControllerTests
    {
        [Fact]
        public void GetInfo_ShouldReturnOkResult()
        {
            // Arrange
            var controller = new CIPipelineController();

            // Act
            var result = controller.GetInfo();

            // Assert
            Assert.NotNull(result);
            var okResult = Assert.IsType<OkObjectResult>(result);
            var response = Assert.IsType<InfoResponse>(okResult.Value);
            Assert.Equal("DevOpsStack CI/CD Demo", response.Application);
            Assert.Equal("1.0.0", response.Version);
        }

        [Fact]
        public void BuildStatus_WithValidProject_ShouldReturnSuccess()
        {
            // Arrange
            var controller = new CIPipelineController();
            var request = new BuildRequest { ProjectName = "DevOpsStack" };

            // Act
            var result = controller.BuildStatus(request);

            // Assert
            Assert.NotNull(result);
            var okResult = Assert.IsType<OkObjectResult>(result);
            var response = Assert.IsType<BuildStatusResponse>(okResult.Value);
            Assert.True(response.Success);
            Assert.Equal("DevOpsStack", response.Project);
            Assert.Contains("Build", response.Steps);
        }

        [Fact]
        public void BuildStatus_WithNullProject_ShouldReturnBadRequest()
        {
            // Arrange
            var controller = new CIPipelineController();
            var request = new BuildRequest { ProjectName = null! };

            // Act
            var result = controller.BuildStatus(request);

            // Assert
            Assert.NotNull(result);
            Assert.IsType<BadRequestObjectResult>(result);
        }

        [Fact]
        public void CI_Pipeline_ShouldIncludeAllStages()
        {
            // Arrange
            var controller = new CIPipelineController();
            var request = new BuildRequest { ProjectName = "TestProject" };
            var expectedStages = new[] { "Restore", "Build", "Test", "Ready for Deployment" };

            // Act
            var result = controller.BuildStatus(request) as OkObjectResult;
            var response = result?.Value as BuildStatusResponse;

            // Assert
            Assert.NotNull(response);
            Assert.Equal(expectedStages, response.Steps);
        }
    }
}
