using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace Constitution1996API.DataHandling
{
    // Repository that contains the methods that access stored procedures 
    // and return data from the DB regarding Main (Chapters 1 - 14)
    public class MainRepository : IMainRepository
    {
        // Create a variable for the context/database connection class
        EntityFrameworkDataContext _entityFramework;

        // Constructor for the class
        // Create a new instance of the connection and save it to the variable above
        public MainRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        // Gets the Preamble of the Constitution and returns it
        public Preamble RetrievePreamble()
        {
            return _entityFramework.Preamble.FromSqlRaw($"[MainSchema].spGetPreamble").AsEnumerable<Preamble>().First();
        }
    }
}