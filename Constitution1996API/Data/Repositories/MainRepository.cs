using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace Constitution1996API.DataHandling
{
    public class MainRepository : IMainRepository
    {
        EntityFrameworkDataContext _entityFramework;

        public MainRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        public Preamble RetrievePreamble()
        {
            return _entityFramework.Preamble.FromSqlRaw($"[MainSchema].spGetPreamble").AsEnumerable<Preamble>().First();
        }
    }
}