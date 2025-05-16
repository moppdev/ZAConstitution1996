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

        // DBSets used to query most models
        public virtual DbSet<Amendment> Amendments {get; set;}
        
        public virtual DbSet<Preamble> Preamble {get; set;}
        public virtual DbSet<Chapter> Chapters {get; set;}
        public virtual DbSet<Section> Sections {get; set;}
        public virtual DbSet<NonDerogableRight> NonDerogableRights {get; set;}
        public virtual DbSet<SectionByChapter> SectionsByChapters {get; set;}
        public virtual DbSet<Subsection> SubsectionBySection {get; set;}
        public virtual DbSet<Clause> ClausesBySubsection {get; set;}

        public virtual DbSet<Annexure> Annexures {get; set;}
        public virtual DbSet<AnnexureSection> AnnexureSections {get; set;}
        public virtual DbSet<AnnexureSubsection> AnnexureSubsections {get; set;}

        public virtual DbSet<ScheduleOne_NationalFlag> ScheduleOne {get; set;}
        public virtual DbSet<ScheduleOneA_GeoAreasProvince> ScheduleOneA {get; set;}
        public virtual DbSet<ScheduleTwo_OathsAffirmation> ScheduleTwo_OathsAffirmations {get; set;}
        public virtual DbSet<ScheduleTwo_Subsection> ScheduleTwo_Subsections {get; set;}
        public virtual DbSet<ScheduleThree_Subsection> ScheduleThree_Subsections {get; set;}
        public virtual DbSet<ScheduleThree_ElectionProcedure> ScheduleThree_ElectionProcedures {get; set;}
        public virtual DbSet<ScheduleThree_Part> ScheduleThree_Parts {get; set;}
        public virtual DbSet<Competency> ScheduleFourFive {get; set;}
        public virtual DbSet<ScheduleSix_Subsection> ScheduleSix_Subsections {get; set;}
        public virtual DbSet<ScheduleSix_TransitionalArrangement> ScheduleSix_TransitionalArrangements {get; set;}
        public virtual DbSet<ScheduleSix_Clause> ScheduleSix_Clauses {get; set;}
        public virtual DbSet<ScheduleSeven_RepealedLaw> ScheduleSeven {get; set;}


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
            modelBuilder.Entity<Chapter>().HasKey("ChapterID");
            modelBuilder.Entity<Section>().HasKey("SectionID");
            modelBuilder.Entity<NonDerogableRight>().HasKey("SectionNumber");
            modelBuilder.Entity<SectionByChapter>().HasKey("SectionID");
            modelBuilder.Entity<Subsection>().HasKey("SubsectionID");
            modelBuilder.Entity<Clause>().HasKey(["ClauseID", "SubsectionID", "SectionID"]);
            
            modelBuilder.Entity<Annexure>().HasKey("AnnexureID");
            modelBuilder.Entity<AnnexureSection>().HasKey(["AnnexureID", "SectionID"]);
            modelBuilder.Entity<AnnexureSubsection>().HasKey(["SectionID", "SubsectionID"]);

            modelBuilder.Entity<ScheduleOneA_GeoAreasProvince>().HasNoKey().ToView(null);
            modelBuilder.Entity<ScheduleOne_NationalFlag>().HasKey("SectionID");
            modelBuilder.Entity<ScheduleTwo_OathsAffirmation>().HasKey("SectionID");
            modelBuilder.Entity<ScheduleTwo_Subsection>().HasKey(["SectionID", "SubsectionID"]);
            modelBuilder.Entity<ScheduleThree_Part>().HasKey(["PartID"]);
            modelBuilder.Entity<ScheduleThree_ElectionProcedure>().HasKey(["SectionID", "SectionThreePart"]);
            modelBuilder.Entity<ScheduleThree_Subsection>().HasKey(["SectionID", "SubsectionID", "SectionThreePart"]);
            modelBuilder.Entity<Competency>().HasKey("PartID");
            modelBuilder.Entity<ScheduleSix_TransitionalArrangement>().HasKey("SectionID");
            modelBuilder.Entity<ScheduleSix_Subsection>().HasKey(["SectionID", "SubsectionID"]);
            modelBuilder.Entity<ScheduleSix_Clause>().HasKey(["ClauseID", "SubsectionID", "SectionID"]);
            modelBuilder.Entity<ScheduleSeven_RepealedLaw>().HasNoKey().ToView(null);
        }
    }
}