using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace Constitution1996API.DataHandling
{
    // Repository that contains the methods that access stored procedures 
    // and return data from the DB regarding Main (Chapters 1 - 14)
    public class MainRepository : IMainRepository
    {
        // Create a variable for the context/database connection class
        private readonly EntityFrameworkDataContext _entityFramework;

        // Constructor for the class
        // Create a new instance of the connection and save it to the variable above
        public MainRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

         // Gets the Preamble of the Constitution
        public async Task<Preamble> GetPreamble()
        {
            var list = await _entityFramework.Preamble
                .FromSqlRaw("[MainSchema].spGetPreamble")
                .ToListAsync();

            return list.FirstOrDefault();
        }


        // Gets the Chapters' IDs and corresponding titles
        public async Task<IEnumerable<Chapter>> GetChapters()
        {
            return await _entityFramework.Chapters
                .FromSqlRaw("[MainSchema].spGetChapters")
                .ToListAsync();
        }

         // Gets all Sections' titles, ids, chapter ids and text if the field isn't null
        public async Task<IEnumerable<Section>> GetSections()
        {
            return await _entityFramework.Sections
                .FromSqlRaw("[MainSchema].spGetSections")
                .ToListAsync();
        }

        // Gets the contents of the Non Derogable Rights table in the Bill of Rights (Chapter 2)
        public async Task<IEnumerable<NonDerogableRight>> GetNonDerogableRights()
        {
            return await _entityFramework.NonDerogableRights
                .FromSqlRaw("[MainSchema].spGetNonDerogableRights")
                .ToListAsync();
        }
    }
}