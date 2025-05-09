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
        public Preamble GetPreamble()
        {
            return _mainRepository.GetPreamble();
        }

        // GET request that returns the Preamble to the Constitution
        [HttpGet("chapters/all")]
        public IEnumerable<Chapter> GetChapters()
        {
            return _mainRepository.GetChapters();
        }

         // GET request that returns all sections' titles, ids and chapter ids
        [HttpGet("sections/all")]
        public IEnumerable<Section> GetSections()
        {
            return _mainRepository.GetSections();
        }

         // GET request that returns the Non Derogable Rights table from the Bill of Rights (Chapter 2)
        [HttpGet("ndr/all")]
        public IEnumerable<NonDerogableRight> GetNonDerogableRights()
        {
            return _mainRepository.GetNonDerogableRights();
        }
    }
}