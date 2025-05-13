using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
 // Repository interface that declares methods for the MainRepository
    public interface IScheduleRepository
    {
        // methods for Schedules

        // methods for Annexures
        public Task<IEnumerable<Annexure>> GetAnnexures();
        public Task<IEnumerable<AnnexureSection>> GetAnnexureSections();
        public Task<IEnumerable<AnnexureSubsection>> GetAnnexureSubsections(char annexureID, int sectionID);
    }
}