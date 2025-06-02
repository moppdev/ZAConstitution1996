using System.Threading.RateLimiting;
using Constitution1996API.DataHandling;
using Microsoft.AspNetCore.RateLimiting;
using Serilog;

// Log configuration
var logger = new LoggerConfiguration().MinimumLevel.Information().WriteTo.Console().CreateLogger();

// Create the App's builder
var builder = WebApplication.CreateBuilder(args);

// Add proper logging
builder.Logging.ClearProviders();
builder.Logging.AddSerilog(logger);

// Add Controllers, look for endpoints and add swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add in CORS handling
builder.Services.AddCors((options) =>
    {
        options.AddPolicy("DevCors", (corsBuilder) =>
            {
                corsBuilder.WithOrigins("http://localhost:4200", "http://localhost:3000", "http://localhost:8000", "http://localhost:5173")
                    .WithMethods("GET")
                    .AllowAnyHeader();
            });
    });

// Initialize and connect the repository interfaces to their classes
builder.Services.AddScoped<IAmendmentRepository, AmendmentRepository>();
builder.Services.AddScoped<IMainRepository, MainRepository>();
builder.Services.AddScoped<IScheduleRepository, ScheduleRepository>();

// Add a rate limiter
builder.Services.AddRateLimiter(options =>
{
    // Add a fixed rate limiting window
    options.AddFixedWindowLimiter("FixedRequestPolicy", ops =>
    {
        // Process older requests first
        ops.QueueProcessingOrder = QueueProcessingOrder.OldestFirst;

        // Request limit
        ops.PermitLimit = 40;

        // Time span that request limit applies E.g. 40 requests a minute
        ops.Window = TimeSpan.FromMinutes(1);

         // HTTP status to return if policy is broken
        options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    });
});

// Build the API
var app = builder.Build();

// Check if env is development or production
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseCors("DevCors");
}
else
{
    app.UseHttpsRedirection();
}

// map controllers and run the API
app.UseRateLimiter();
app.MapControllers();
app.Run();
