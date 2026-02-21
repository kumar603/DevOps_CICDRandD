namespace DevopsStack.API.Models
{
    public class InfoResponse
    {
        public string Application { get; set; } = string.Empty;
        public string Version { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string Framework { get; set; } = string.Empty;
        public DateTimeOffset Timestamp { get; set; }
    }

    public class BuildStatusResponse
    {
        public bool Success { get; set; }
        public string Project { get; set; } = string.Empty;
        public string Stage { get; set; } = string.Empty;
        public string[] Steps { get; set; } = [];
    }
}