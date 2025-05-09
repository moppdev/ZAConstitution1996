using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
     // Repository interface that declares methods for the MainRepository
    public interface IMainRepository
    {
        // methods
        public Task<Preamble> GetPreamble();
        public Task<IEnumerable<Chapter>> GetChapters();
        public Task<IEnumerable<Section>> GetSections();
        public Task<IEnumerable<NonDerogableRight>> GetNonDerogableRights();
    }
}