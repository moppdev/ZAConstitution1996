using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;

namespace Constitution1996API.Controllers
{
    // Controller that handles all routes related to Amendments

    // Define that the following class is a controller
    // Define its route
    [ApiController]
    [Route("api/v1/amendments")]
    public class AmendmentController: ControllerBase
    {
        // Create a variable to store an instance of AmendmentRepository's interface
        IAmendmentRepository _amendmentRepository;

         // Call the interface of AmendmentRepository via dependency injection and assign it to 
         // the variable above
        public AmendmentController(IAmendmentRepository amendmentRepository)
        {
            _amendmentRepository = amendmentRepository;
        }

        // GET request that returns all amendments to the Constitution to date
        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<Amendment>>> GetAmendments()
        {
            IEnumerable<Amendment> amendments = await _amendmentRepository.GetAmendments();

            if (amendments == null || !amendments.Any())
            {
                return NotFound();
            }

            return amendments.ToList();
        }
    }
}