using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Identity.Client;
using Microsoft.IdentityModel.Tokens;

namespace Constitution1996API.Controllers
{
     // Controller that handles all requests related to Schedules


    // Define that the following class is a controller
    // Define its main route
    [ApiController]
    [Route("api/v1/schedules")]
    public class ScheduleController: ControllerBase
    {
        
    }

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
        [HttpGet("all")]
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
            return annexures.ToList();
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

            IEnumerable<AnnexureSection> annexureSections = await _scheduleRepository.GetAnnexureSections();
            var sections = annexureSections.Where(sec => sec.AnnexureID == annexureID);

            // if null return 404
            if (sections == null)
            {
                return NotFound($"Error: Sections for Annexure {annexureID} not found");
            }

            List<IEnumerable<AnnexureSubsection>> annexureSubsections = [];
            foreach (var section in sections)
            {
                var subs = await _scheduleRepository.GetAnnexureSubsections(annexureID, section.SectionID);
                if (!subs.IsNullOrEmpty())
                {
                    annexureSubsections.Add(subs);
                }
            } // TODO: FIX SUBSECTIONS - add sectionID too

            if (annexureSubsections.IsNullOrEmpty())
            {
                return new FullAnnexure(annexure.AnnexureID, annexure.AnnexureTitle, sections, null);
            }

            return new FullAnnexure(annexure.AnnexureID, annexure.AnnexureTitle, sections, annexureSubsections);
        }


    }
}