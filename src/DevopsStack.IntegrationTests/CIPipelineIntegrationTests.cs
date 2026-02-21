using Xunit;
using Microsoft.AspNetCore.Mvc.Testing;
using DevopsStack.API;

namespace DevopsStack.IntegrationTests
{
    public class CIPipelineIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public CIPipelineIntegrationTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory;
        }

        [Fact]
        public async Task GetInfo_EndpointShouldReturnStatus200()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = await client.GetAsync("/api/cipeline/info");

            // Assert
            Assert.True(response.IsSuccessStatusCode);
        }

        [Fact]
        public async Task BuildStatus_WithValidRequest_ShouldReturn200()
        {
            // Arrange
            var client = _factory.CreateClient();
            var content = new StringContent(
                "{\"projectName\":\"DevOpsStack\"}", 
                System.Text.Encoding.UTF8, 
                "application/json"
            );

            // Act
            var response = await client.PostAsync("/api/cipeline/build-status", content);

            // Assert
            Assert.True(response.IsSuccessStatusCode);
        }
    }
}
