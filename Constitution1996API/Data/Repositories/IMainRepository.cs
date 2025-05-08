using Constitution1996API.Models;

namespace Constitution1996API.DataHandling
{
     // Repository interface that declares methods for the MainRepository
    public interface IMainRepository
    {
        // methods
        public Preamble RetrievePreamble();
    }
}