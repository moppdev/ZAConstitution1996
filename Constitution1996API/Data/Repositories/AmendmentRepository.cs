using Constitution1996API.Models;
using Microsoft.EntityFrameworkCore;

namespace  Constitution1996API.DataHandling
{
    public class AmendmentRepository: IAmendmentRepository
    {
        EntityFrameworkDataContext _entityFramework;

        public AmendmentRepository(IConfiguration config)
        {
            _entityFramework = new EntityFrameworkDataContext(config);
        }

        public IEnumerable<Amendment> GetAmendments()
        {
            return _entityFramework.Amendments.FromSqlRaw($"[AmendmentSchema].spGetAmendments");
        }
    }
}