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
        // gets the contents of Schedule 1, which describes the national flag's appearance
        public async Task<IEnumerable<ScheduleOne_NationalFlag>> GetScheduleOne_NationalFlag()
        {
            return await _entityFramework.ScheduleOne.FromSqlRaw($"[ScheduleSchema].spGetScheduleOne_NationalFlag").ToListAsync();
        }        
        
        // gets the contents of Schedule 1A, which describes the borders and demarcations of provinces
        public async Task<IEnumerable<ScheduleOneA_GeoAreasProvinces>> GetScheduleOneA_GeoAreasProvinces()
        {
            return await _entityFramework.ScheduleOneA.FromSqlRaw($"[ScheduleSchema].spGetScheduleOneA_GeoAreasProvinces").ToListAsync();
        }

        // gets the contents of Schedule 4, which describes competencies that both provincial and national governments share
        public async Task<IEnumerable<Competency>> GetScheduleFour()
        {
            return await _entityFramework.ScheduleFourFive.FromSqlRaw($"[ScheduleSchema].spGetScheduleFour_ConcurrentCompetencies").ToListAsync();
        }

        // gets the contents of Schedule 5, which describes competencies that both provincial and national governments share
        public async Task<IEnumerable<Competency>> GetScheduleFive()
        {
            return await _entityFramework.ScheduleFourFive.FromSqlRaw($"[ScheduleSchema].spGetScheduleFive_ExclusiveProvincialCompetencies").ToListAsync();
        }

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
        public async Task<IEnumerable<AnnexureSubsection>> GetAnnexureSubsections(char annexureID)
        {
            SqlParameter param = new SqlParameter("@AnnexureID", annexureID);
            return await _entityFramework.AnnexureSubsections.FromSqlRaw($"[ScheduleSchema].spGetAnnexureSubsections @AnnexureID", param).ToListAsync();
        }
    }   
}