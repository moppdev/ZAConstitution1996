using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;

namespace Constitution1996API.Controllers
{
    // Controller that handles all requests related to Main (Chapter 1 -14)

    // Define that the following class is a controller
    // Define its main route
    [ApiController]
    [Route("api/v1/main")]
    public class MainController: ControllerBase
    {
        // Create a variable to store an instance of MainRepository's interface
        IMainRepository _mainRepository;

        // Call the interface of MainRepository via dependency injection and assign it to 
         // the variable above
        public MainController(IMainRepository mainRepository)
        {
            _mainRepository = mainRepository;
        }

        // GET request that returns the Preamble to the Constitution
        [HttpGet("preamble")]
        public async Task<ActionResult<Preamble>> GetPreamble()
        {
            // async load the method
            Preamble preamble = await _mainRepository.GetPreamble();

            // check if result is null or empty
            if (preamble == null)
            {
                // return 404
                return NotFound();
            }
            
            // Else, return result
            return preamble;
        }

        // GET request that returns the Preamble to the Constitution
        [HttpGet("chapters/all")]
        public async Task<ActionResult<IEnumerable<Chapter>>> GetChapters()
        {
            // async load the method
            IEnumerable<Chapter> chapters = await _mainRepository.GetChapters();

            // check if result is null or empty
            if (chapters == null || !chapters.Any())
            {
                // return 404
                return NotFound();
            }

             // Else, return result
            return chapters.ToList();
        }

         // GET request that returns all sections' titles, ids and text if not null
        [HttpGet("sections/all")]
        public async Task<ActionResult<IEnumerable<Section>>> GetSections()
        {
            // async load the method
            IEnumerable<Section> sections = await _mainRepository.GetSections();

            // check if result is null or empty
            if (sections == null || !sections.Any())
            {
                return NotFound();
            }

            // Else, return result
            return sections.ToList();
        }

         // GET request that returns the Non Derogable Rights table from the Bill of Rights (Chapter 2)
        [HttpGet("ndr/all")]
        public async Task<ActionResult<IEnumerable<NonDerogableRight>>> GetNonDerogableRights()
        {
            // async load the method
            IEnumerable<NonDerogableRight> nonDerogableRights = await _mainRepository.GetNonDerogableRights();

            // check if result is null or empty
            if (nonDerogableRights == null || !nonDerogableRights.Any())
            {
                return NotFound();
            }

            // Else, return result
            return nonDerogableRights.ToList();
        }
    }
}