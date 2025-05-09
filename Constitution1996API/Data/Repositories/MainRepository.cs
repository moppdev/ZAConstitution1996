using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace Constitution1996API.DataHandling
{
    // Repository that contains the methods that access stored procedures 
    // and return data from the DB regarding Main (Chapters 1 - 14)
    public class MainRepository : IMainRepository
    {
        // Create a variable for the context/database connection class
        EntityFrameworkDataContext _entityFramework;

        // Constructor for the class
        // Create a new instance of the connection and save it to the variable above
        public MainRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        // Gets the Preamble of the Constitution
        public Preamble GetPreamble()
        {
            return _entityFramework.Preamble.FromSqlRaw($"[MainSchema].spGetPreamble").AsEnumerable<Preamble>().First();
        }

        // Gets the Chapters' IDs and corresponding titles
        public IEnumerable<Chapter> GetChapters()
        {
            return _entityFramework.Chapters.FromSqlRaw($"[MainSchema].spGetChapters");
        }

        // Gets all Sections' titles, ids, chapter ids and text if the field isn't null
        public IEnumerable<Section> GetSections()
        {
            return _entityFramework.Sections.FromSqlRaw($"[MainSchema].spGetSections");
        }

        // Gets the contents of the Non Derogable Rights table in the Bill of Rights (Chapter 2)
        public IEnumerable<NonDerogableRight> GetNonDerogableRights()
        {
            return _entityFramework.NonDerogableRights.FromSqlRaw($"[MainSchema].spGetNonDerogableRights");
        }
    }
}