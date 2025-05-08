using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;

namespace Constitution1996API.Controllers
{
    [ApiController]
    [Route("api/v1/amendments")]
    public class AmendmentController: ControllerBase
    {
        IAmendmentRepository _amendmentRepository;
        public AmendmentController(IAmendmentRepository amendmentRepository)
        {
            _amendmentRepository = amendmentRepository;
        }

        [HttpGet("all")]
        public IEnumerable<Amendment> GetAmendments()
        {
            return _amendmentRepository.GetAmendments();
        }
    }
}