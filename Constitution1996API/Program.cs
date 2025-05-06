var builder = WebApplication.CreateBuilder(args);

// Add Controllers, look for endpoints and add swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Check if env is development or production
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHttpsRedirection();   
}

// map controllers and run the API
app.MapControllers();
app.Run();
