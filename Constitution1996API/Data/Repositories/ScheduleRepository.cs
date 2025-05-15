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
        public async Task<IEnumerable<ScheduleOneA_GeoAreasProvince>> GetScheduleOneA_GeoAreasProvinces()
        {
            return await _entityFramework.ScheduleOneA.FromSqlRaw($"[ScheduleSchema].spGetScheduleOneA_GeoAreasProvinces").ToListAsync();
        }

        // gets the contents of Schedule 2, which describes oaths that public representatives take when sworn into office
        public async Task<IEnumerable<ScheduleTwo_OathsAffirmation>> GetScheduleTwo_OathsAffirmations()
        {
            return await _entityFramework.ScheduleTwo_OathsAffirmations.FromSqlRaw($"[ScheduleSchema].spGetScheduleTwo_OathsAffirmations").ToListAsync();
        }

        // gets the subsections, if any, of Schedule 2
        public async Task<IEnumerable<ScheduleTwo_Subsection>> GetScheduleTwo_Subsections(int sectionID)
        {
            SqlParameter param = new SqlParameter("@SectionID", sectionID);
            return await _entityFramework.ScheduleTwo_Subsections.FromSqlRaw($"[ScheduleSchema].spGetScheduleTwo_Subsection @SectionID", param).ToListAsync();
        }

        // gets the parts of Schedule 3
        public async Task<IEnumerable<ScheduleThree_Part>> GetScheduleThree_Parts()
        {
            return await _entityFramework.ScheduleThree_Parts.FromSqlRaw($"[ScheduleSchema].spGetScheduleThree_Parts").ToListAsync();
        }

        // gets the contents of Schedule 3, which describes election processes in Parliament and Provincial Legislatures
        public async Task<IEnumerable<ScheduleThree_ElectionProcedure>> GetScheduleThree_ElectionProcedures()
        {
            return await _entityFramework.ScheduleThree_ElectionProcedures.FromSqlRaw($"[ScheduleSchema].spGetScheduleThree_ElectionProcedures").ToListAsync();
        }

        // gets the subsections, if any, of Schedule 3
        public async Task<IEnumerable<ScheduleThree_Subsection>> GetScheduleThree_Subsections()
        {
            return await _entityFramework.ScheduleThree_Subsections.FromSqlRaw($"[ScheduleSchema].spGetScheduleThree_Subsections").ToListAsync();
        }

        // gets the contents of Schedule 4, which describes competencies that both provincial and national governments share
        public async Task<IEnumerable<Competency>> GetScheduleFour()
        {
            return await _entityFramework.ScheduleFourFive.FromSqlRaw($"[ScheduleSchema].spGetScheduleFour_ConcurrentCompetencies").ToListAsync();
        }

        // gets the contents of Schedule 5, which describes competencies that are exclusively under provincial control
        public async Task<IEnumerable<Competency>> GetScheduleFive()
        {
            return await _entityFramework.ScheduleFourFive.FromSqlRaw($"[ScheduleSchema].spGetScheduleFive_ExclusiveProvincialCompetencies").ToListAsync();
        }

        // gets the contents of Schedule 6, which describes transitional arrangments made, that lasted until the 1999 elections and some until the 1996 Constitution was implemented
        public async Task<IEnumerable<ScheduleSix_TransitionalArrangement>> GetScheduleSix_TransitionalArrangements()
        {
            return await _entityFramework.ScheduleSix_TransitionalArrangements.FromSqlRaw($"[ScheduleSchema].spGetScheduleSix_TransitionalArrangements").ToListAsync();
        }

        // gets the subsections, if any, of Schedule 6
        public async Task<IEnumerable<ScheduleSix_Subsection>> GetScheduleSix_Subsections()
        {
            return await _entityFramework.ScheduleSix_Subsections.FromSqlRaw($"[ScheduleSchema].spGetScheduleSix_Subsections").ToListAsync();
        }

        // gets the clauses, if any, of subsections of Schedule 6
        public async Task<IEnumerable<ScheduleSix_Clause>> GetScheduleSix_Clauses()
        {
            return await _entityFramework.ScheduleSix_Clauses.FromSqlRaw($"ScheduleSchema.spGetScheduleSix_Clauses").ToListAsync();
        }

        // gets the contents of Schedule 7, which describes laws/amendments that have been repealed
        public async Task<IEnumerable<ScheduleSeven_RepealedLaw>> GetScheduleSeven()
        {
            return await _entityFramework.ScheduleSeven.FromSqlRaw($"[ScheduleSchema].spGetScheduleSeven_RepealedLaws").ToListAsync();
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