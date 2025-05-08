using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;

namespace Constitution1996API.Controllers
{
    [ApiController]
    [Route("api/v1/main")]
    public class MainController: ControllerBase
    {
        IMainRepository _mainRepository;

        public MainController(IMainRepository mainRepository)
        {
            _mainRepository = mainRepository;
        }

        [HttpGet("preamble")]
        public Preamble GetPreamble()
        {
            return _mainRepository.RetrievePreamble();
        }
    }
}