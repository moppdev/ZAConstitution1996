using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
 // Repository interface that declares methods for the ScheduleRepository
    public interface IScheduleRepository
    {
        // methods for Schedules
        public Task<IEnumerable<ScheduleOne_NationalFlag>> GetScheduleOne_NationalFlag();
        public Task<IEnumerable<ScheduleOneA_GeoAreasProvince>> GetScheduleOneA_GeoAreasProvinces();
        public Task<IEnumerable<ScheduleTwo_OathsAffirmation>> GetScheduleTwo_OathsAffirmations();
        public Task<IEnumerable<ScheduleTwo_Subsection>> GetScheduleTwo_Subsections(int sectionID);
        public Task<IEnumerable<ScheduleThree_Part>> GetScheduleThree_Parts();
        public Task<IEnumerable<ScheduleThree_ElectionProcedure>> GetScheduleThree_ElectionProcedures();
        public Task<IEnumerable<ScheduleThree_Subsection>> GetScheduleThree_Subsections();
        public Task<IEnumerable<Competency>> GetScheduleFour();
        public Task<IEnumerable<Competency>> GetScheduleFive();
        public Task<IEnumerable<ScheduleSix_TransitionalArrangement>> GetScheduleSix_TransitionalArrangements();
        public Task<IEnumerable<ScheduleSix_Subsection>> GetScheduleSix_Subsections();
        public Task<IEnumerable<ScheduleSix_Clause>> GetScheduleSix_Clauses();
        public Task<IEnumerable<ScheduleSeven_RepealedLaw>> GetScheduleSeven();

        // methods for Annexures
        public Task<IEnumerable<Annexure>> GetAnnexures();
        public Task<IEnumerable<AnnexureSection>> GetAnnexureSections();
        public Task<IEnumerable<AnnexureSubsection>> GetAnnexureSubsections(char annexureID);
    }
}