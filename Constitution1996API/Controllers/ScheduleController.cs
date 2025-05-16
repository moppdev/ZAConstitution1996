using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;
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
            return Ok(scheduleOne);
        }

        // GET request that returns the content of Schedule 1A
        [HttpGet("one/a")]
        public async Task<ActionResult<IEnumerable<ScheduleOneA_GeoAreasProvince>>> GetScheduleOneA_GeoAreasProvinces()
        {
            // async load the method
           IEnumerable<ScheduleOneA_GeoAreasProvince> scheduleOneA = await _scheduleRepository.GetScheduleOneA_GeoAreasProvinces();

            // check if result is null or empty
            if (scheduleOneA.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 1A could not be found.");
            }

             // Else, return result
            return Ok(scheduleOneA);
        }

        // GET request that returns the content of Schedule 2
        [HttpGet("two")]
        public async Task<ActionResult<IEnumerable<ScheduleTwo_Full>>> GetScheduleTwo_OathsAffirmations()
        {
            // get the contents of schedule two
            IEnumerable<ScheduleTwo_OathsAffirmation> scheduleTwo = await _scheduleRepository.GetScheduleTwo_OathsAffirmations();

            // if null/empty, return 404
            if (scheduleTwo.IsNullOrEmpty())
            {
                return NotFound("Error: Contents of Schedule 2 could not be found.");
            }

            // Get all subsections via looping through section by section
            List<IEnumerable<ScheduleTwo_Subsection>> scheduleTwo_Subsections = [];
            foreach (var section in scheduleTwo)
            {
                var sub = await _scheduleRepository.GetScheduleTwo_Subsections(section.SectionID);
                if (!sub.IsNullOrEmpty())
                {
                    scheduleTwo_Subsections.Add(sub);
                }
            }

            // if subsections are null/empty, return object without subsections
            if (scheduleTwo_Subsections.IsNullOrEmpty())
            {
                return Ok(new ScheduleTwo_Full(scheduleTwo, null));
            }

            // return Schedule 2's contents
            return Ok(new ScheduleTwo_Full(scheduleTwo, scheduleTwo_Subsections));
        }


        //GET request that returns the content of Schedule 3
        [HttpGet("three")]
        public async Task<ActionResult<IEnumerable<ScheduleThree_Full>>> GetScheduleThree_ElectionProcedures()
        {
            // get the parts that the schedule is divided into
            IEnumerable<ScheduleThree_Part> parts = await _scheduleRepository.GetScheduleThree_Parts();

            // Get the contents
            IEnumerable<ScheduleThree_ElectionProcedure> electionProcedures = await _scheduleRepository.GetScheduleThree_ElectionProcedures();

            // If null/empty, return 404
            if (parts.IsNullOrEmpty() || electionProcedures.IsNullOrEmpty())
            {
                return NotFound("Error: Contents of Schedule 3 could not be found.");
            }

            // Get subsections
            IEnumerable<ScheduleThree_Subsection> scheduleThree_Subsections = await _scheduleRepository.GetScheduleThree_Subsections();

            // If subsections null/empty, return the schedule without subsections
            if (scheduleThree_Subsections.IsNullOrEmpty())
            {
                return Ok(new ScheduleThree_Full(parts, electionProcedures, null));
            }

            // return Schedule 3's contents
            return Ok(new ScheduleThree_Full(parts, electionProcedures, scheduleThree_Subsections));
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
                return NotFound("Error: Contents of Schedule 4 could not be found.");
            }

             // Else, return result
            return Ok(scheduleFour);
        }

        // GET request that returns the content of Schedule 5
        [HttpGet("five")]
        public async Task<ActionResult<IEnumerable<Competency>>> GetScheduleFour_ConcurrentCompetencies()
        {
            // async load the method
           IEnumerable<Competency> scheduleFive = await _scheduleRepository.GetScheduleFive();

            // check if result is null or empty
            if (scheduleFive.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 5 could not be found.");
            }

             // Else, return result
            return Ok(scheduleFive);
        }

        //GET request that returns the content of Schedule 6
        [HttpGet("six")]
        public async Task<ActionResult<IEnumerable<ScheduleSix_Full>>> GetScheduleSix_TransititionalArrangements()
        {
            // Get the contents of schedule 6
            IEnumerable<ScheduleSix_TransitionalArrangement> scheduleSix = await _scheduleRepository.GetScheduleSix_TransitionalArrangements();

            // if null/empty, return 404
            if (scheduleSix.IsNullOrEmpty())
            {
                return NotFound("Error: Contents of Schedule 6 could not be found.");
            }

            // Get the subsections, if any, of schedule 6
            IEnumerable<ScheduleSix_Subsection> scheduleSix_Subsections = await _scheduleRepository.GetScheduleSix_Subsections();

            // if null/empty return full schedule without subsections or clauses
            if (scheduleSix_Subsections.IsNullOrEmpty())
            {
                return Ok(new ScheduleSix_Full(scheduleSix, null, null));
            }

            // Get the clauses, if any, of schedule 6
            IEnumerable<ScheduleSix_Clause> scheduleSix_Clauses = await _scheduleRepository.GetScheduleSix_Clauses();

             // if null/empty return full schedule without clauses
            if (scheduleSix_Clauses.IsNullOrEmpty())
            {
                return Ok(new ScheduleSix_Full(scheduleSix, scheduleSix_Subsections, null));
            }

            // return the full schedule
            return Ok(new ScheduleSix_Full(scheduleSix, scheduleSix_Subsections, scheduleSix_Clauses));
        }

         // GET request that returns the content of Schedule 7
        [HttpGet("seven")]
        public async Task<ActionResult<IEnumerable<ScheduleSeven_RepealedLaw>>> GetScheduleSeven()
        {
            // async load the method
            IEnumerable<ScheduleSeven_RepealedLaw> scheduleSeven = await _scheduleRepository.GetScheduleSeven();

            // check if result is null or empty
            if (scheduleSeven.IsNullOrEmpty())
            {
                // return 404
                return NotFound("Error: Contents of Schedule 7 could not be found.");
            }

             // Else, return result
            return Ok(scheduleSeven);
        }
    }
}