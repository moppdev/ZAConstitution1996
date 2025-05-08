using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

/* 
    This file connects the API to the Constitution1996DB.
    Entity Framework Core is used here
*/
namespace Constitution1996API.DataHandling
{

    // class that will be used to instantiate and maintain the connection to the DB
    public class EntityFrameworkDataContext: DbContext
    {
        private readonly IConfiguration _config;

        // Get the config from appsettings.json via Dependency injection
        public EntityFrameworkDataContext(IConfiguration config)
        {
            // Make _config global and set it with config
            _config = config;
        }

        // DBSets used to query models
        public virtual DbSet<Amendment> Amendments {get; set;}
        public virtual DbSet<Preamble> Preamble {get; set;}

        // When the connection is configuring itself
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            // Check if the connection is configured, otherwise create a connection
            if (!optionsBuilder.IsConfigured)
            {

                optionsBuilder.UseSqlServer(_config.GetConnectionString("DefaultConnection"),
                        optionsBuilder => optionsBuilder.EnableRetryOnFailure());
            }
        }

        // Assign certain properties/values, etc to Models
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Amendment>().HasNoKey().ToView(null);
            modelBuilder.Entity<Preamble>().HasNoKey().ToView(null);
        }
    }
}