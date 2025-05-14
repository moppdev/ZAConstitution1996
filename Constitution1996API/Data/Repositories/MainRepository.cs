using Constitution1996API.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Data.SqlClient;
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
                .FromSql($"[MainSchema].spGetChapters")
                .ToListAsync();
        }

         // Gets all Sections' titles, ids, chapter ids and text if the field isn't null
        public async Task<IEnumerable<Section>> GetSections()
        {
            return await _entityFramework.Sections
                .FromSql($"[MainSchema].spGetSections")
                .ToListAsync();
        }

        // Gets the contents of the Non Derogable Rights table in the Bill of Rights (Chapter 2)
        public async Task<IEnumerable<NonDerogableRight>> GetNonDerogableRights()
        {
            return await _entityFramework.NonDerogableRights
                .FromSql($"[MainSchema].spGetNonDerogableRights")
                .ToListAsync();
        }

        // Gets the sections of a specific chapter
        public async Task<IEnumerable<SectionByChapter>> GetSectionsByChapterID(int chapterID)
        {
            SqlParameter param = new SqlParameter("@SectionID", chapterID);
            return await _entityFramework.SectionsByChapters.FromSqlRaw($"[MainSchema].spGetSectionsByChapterID @SectionID", param).ToListAsync();
        } 

        // gets the subsections of a section
        public async Task<IEnumerable<Subsection>> GetSubSectionsBySectionID(int sectionID)
        {
            SqlParameter param = new SqlParameter("@SectionID", sectionID);
            return await _entityFramework.SubsectionBySection.FromSqlRaw($"[MainSchema].spGetSubSectionsBySectionID @SectionID", param).ToListAsync();
        }

        // gets the clauses of a subsection of a section
        public async Task<IEnumerable<Clause>> GetClausesOfSubsection(int sectionID)
        {
            SqlParameter param = new SqlParameter("@SectionID", sectionID);
            return await _entityFramework.ClausesBySubsection.FromSqlRaw($"[MainSchema].spGetClausesOfSubsection @SectionID", param).ToListAsync();
        }
    }
}