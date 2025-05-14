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
        public async Task<IEnumerable<ScheduleOne_NationalFlag>> GetScheduleOne_NationalFlag()
        {
            return await _scheduleRepository.GetScheduleOne_NationalFlag();
        }

        // GET request that returns the content of Schedule 1A
        [HttpGet("onea")]
        public async Task<IEnumerable<ScheduleOneA_GeoAreasProvinces>> GetScheduleOneA_GeoAreasProvinces()
        {
            return await _scheduleRepository.GetScheduleOneA_GeoAreasProvinces();
        }
    }
}