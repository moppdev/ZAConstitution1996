using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace  Constitution1996API.DataHandling
{
    // Repository that contains the methods that access stored procedures 
    // and return data from the DB regarding Amendments
    public class AmendmentRepository: IAmendmentRepository
    {
        // Create a variable for the context/database connection class
        EntityFrameworkDataContext _entityFramework;

        // Constructor for the class
        // Create a new instance of the connection and save it to the variable above
        public AmendmentRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        // Gets all Amendments of the Constitution to date and returns an Enumerable containing the data
        public async Task<IEnumerable<Amendment>> GetAmendments()
        {
            return await _entityFramework.Amendments.FromSqlRaw($"[AmendmentSchema].spGetAmendments").ToListAsync();
        }
    }
}