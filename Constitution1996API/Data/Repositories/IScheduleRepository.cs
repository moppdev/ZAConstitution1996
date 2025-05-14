using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
 // Repository interface that declares methods for the MainRepository
    public interface IScheduleRepository
    {
        // methods for Schedules
        public Task<IEnumerable<ScheduleOne_NationalFlag>> GetScheduleOne_NationalFlag();
        public Task<IEnumerable<ScheduleOneA_GeoAreasProvinces>> GetScheduleOneA_GeoAreasProvinces();
        public Task<IEnumerable<Competency>> GetScheduleFour();
        public Task<IEnumerable<Competency>> GetScheduleFive();

        // methods for Annexures
        public Task<IEnumerable<Annexure>> GetAnnexures();
        public Task<IEnumerable<AnnexureSection>> GetAnnexureSections();
        public Task<IEnumerable<AnnexureSubsection>> GetAnnexureSubsections(char annexureID);
    }
}