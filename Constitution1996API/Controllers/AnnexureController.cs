using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace Constitution1996API.Controllers
{
    // Controller that handles all requests related to Annexures

    // Define that the following class is a controller
    // Define its main route
    [ApiController]
    [Route("api/v1/annexures")]
    public class AnnexureController: ControllerBase
    {
        private readonly IScheduleRepository _scheduleRepository;

        public AnnexureController(IScheduleRepository scheduleRepository)
        {
            // initialize the schedule repository
            _scheduleRepository = scheduleRepository;
        }

        // GET request that returns all annexures' ids and titles
        [HttpGet("")]
        public async Task<ActionResult<IEnumerable<Annexure>>> GetAnnexures()
        {
            // get the annexures from the DB
            IEnumerable<Annexure> annexures = await _scheduleRepository.GetAnnexures();

            // if null or empty, return a 404
            if (annexures.IsNullOrEmpty())
            {
                return NotFound("Error: annexures could not be found");
            }

            // return the annexures
            return Ok(annexures);
        }

        // GET request that returns the full content of an annexure
        [HttpGet("{annexureID}/full")]
        public async Task<ActionResult<FullAnnexure>> GetFullAnnexure(char annexureID)
        {
            // Get all annexures
            IEnumerable<Annexure> annexures = await _scheduleRepository.GetAnnexures();

            // search for the annexure's id and title
            var annexure = annexures.FirstOrDefault(ann => ann.AnnexureID == annexureID);

            // if null return 404
            if (annexure == null)
            {
                return NotFound("Error: Annexure not found");
            }

            // Get all sections and use LINQ to find the annexure's sections
            IEnumerable<AnnexureSection> annexureSections = await _scheduleRepository.GetAnnexureSections();
            var sections = annexureSections.Where(sec => sec.AnnexureID == annexureID);

            // if null return 404
            if (sections == null)
            {
                return NotFound($"Error: Sections for Annexure {annexureID} not found");
            }

            // get subsections, if any
            IEnumerable<AnnexureSubsection> annexureSubsections = await _scheduleRepository.GetAnnexureSubsections(annexureID);

            // if no subsections are found, retun FullAnnexure without subsections
            if (annexureSubsections.IsNullOrEmpty())
            {
                return Ok(new FullAnnexure(annexure.AnnexureID, annexure.AnnexureTitle, sections, null));
            }

            // Otherwise, return FullAnnexure as intended
            return Ok(new FullAnnexure(annexure.AnnexureID, annexure.AnnexureTitle, sections, annexureSubsections));
        }
    }
}