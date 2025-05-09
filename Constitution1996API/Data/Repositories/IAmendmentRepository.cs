using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
    // Repository interface that declares methods for the AmendmentRepository
    public interface IAmendmentRepository
    {

        // methods
        public Task<IEnumerable<Amendment>> GetAmendments();
    }
}