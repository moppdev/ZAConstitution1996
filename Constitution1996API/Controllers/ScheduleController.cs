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
        private readonly IScheduleRepository _scheduleRepository;

        public ScheduleController(IScheduleRepository scheduleRepository)
        {
            // initialize the schedule repository
            _scheduleRepository = scheduleRepository;
        }

        // GET request that returns the content of Schedule 1
        [HttpGet("one")]
        public async Task<ActionResult<IEnumerable<ScheduleOne_NationalFlag>>> GetScheduleOne_NationalFlag()
        {
            // async load the method
           IEnumerable<ScheduleOne_NationalFlag> scheduleOne = await _scheduleRepository.GetScheduleOne_NationalFlag();

            // check if result is null or empty
            if (scheduleOne.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 1 could not be found.");
            }

             // Else, return result
            return scheduleOne.ToList();
        }

        // GET request that returns the content of Schedule 1A
        [HttpGet("one/a")]
        public async Task<ActionResult<IEnumerable<ScheduleOneA_GeoAreasProvinces>>> GetScheduleOneA_GeoAreasProvinces()
        {
            // async load the method
           IEnumerable<ScheduleOneA_GeoAreasProvinces> scheduleOneA = await _scheduleRepository.GetScheduleOneA_GeoAreasProvinces();

            // check if result is null or empty
            if (scheduleOneA.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 1A could not be found.");
            }

             // Else, return result
            return scheduleOneA.ToList();
        }

        // GET request that returns the content of Schedule 4
        [HttpGet("four")]
        public async Task<ActionResult<IEnumerable<Competency>>> GetScheduleFive_ExclusiveProvincialCompetencies()
        {
            // async load the method
           IEnumerable<Competency> scheduleFour = await _scheduleRepository.GetScheduleFour();

            // check if result is null or empty
            if (scheduleFour.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 1 could not be found.");
            }

             // Else, return result
            return scheduleFour.ToList();
        }

        // GET request that returns the content of Schedule 5
        [HttpGet("five")]
        public async Task<ActionResult<IEnumerable<Competency>>> GetScheduleFour_ConcurrentCompetencies()
        {
            // async load the method
           IEnumerable<Competency> scheduleFive = await _scheduleRepository.GetScheduleFour();

            // check if result is null or empty
            if (scheduleFive.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 5 could not be found.");
            }

             // Else, return result
            return scheduleFive.ToList();
        }
    }
}