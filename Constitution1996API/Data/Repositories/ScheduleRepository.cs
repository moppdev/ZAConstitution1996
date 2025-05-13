using Constitution1996API.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace Constitution1996API.DataHandling
{
    // Repository that contains the methods that access stored procedures 
    // and return data from the DB regarding Schedules and Annexures
    public class ScheduleRepository: IScheduleRepository
    {
        // Create a variable for the context/database connection class
        private readonly EntityFrameworkDataContext _entityFramework;

        // Constructor for the class
        // Create a new instance of the connection and save it to the variable above
        public ScheduleRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        /// SCHEDULES ///


        /// ANNEXURES //
        // gets the annexures' ids and titles
        public async Task<IEnumerable<Annexure>> GetAnnexures()
        {
            return await _entityFramework.Annexures.FromSqlRaw($"[ScheduleSchema].spGetAnnexures").ToListAsync();
        }

        // gets the sections of an annexure
        public async Task<IEnumerable<AnnexureSection>> GetAnnexureSections()
        {
            return await _entityFramework.AnnexureSections.FromSqlRaw($"[ScheduleSchema].spGetAnnexureSections").ToListAsync();
        }

        // gets subsections of an annexure section
        public async Task<IEnumerable<AnnexureSubsection>> GetAnnexureSubsections(char annexureID, int sectionID)
        {
            SqlParameter param = new SqlParameter("@AnnexureID", annexureID);
            SqlParameter paramTwo = new SqlParameter("@SectionID", sectionID);
            return await _entityFramework.AnnexureSubsections.FromSqlRaw($"[ScheduleSchema].spGetAnnexureSubsections @AnnexureID, @SectionID", param, paramTwo).ToListAsync();
        }
    }   
}