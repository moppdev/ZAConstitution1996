using Constitution1996API.DataHandling;
using Constitution1996API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Query.SqlExpressions;
using Microsoft.IdentityModel.Tokens;

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
                return NotFound("Error: Preamble not found");
            }
            
            // Else, return result
            return preamble;
        }



        // GET request that returns all chapters' titles and ids
        [HttpGet("chapters/all")]
        public async Task<ActionResult<IEnumerable<Chapter>>> GetChapters()
        {
            // async load the method
            IEnumerable<Chapter> chapters = await _mainRepository.GetChapters();

            // check if result is null or empty
            if (chapters == null || !chapters.Any())
            {
                // return 404
                return NotFound("Error: No chapters could be found");
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
                return NotFound("Error: no sections could be found.");
            }

            // Else, return result
            return sections.ToList();
        }



         // GET request that returns the sections of a specific chapter
        [HttpGet("chapter/{chapterID}/sections")]
        public async Task<ActionResult<IEnumerable<SectionByChapter>>> GetSectionsByChapter(int chapterID)
        {
            // check for valid chapter ID
            if (chapterID >= 0 && chapterID <= 14)
            {
                // async load the method
                IEnumerable<SectionByChapter> sectionsByChapter = await _mainRepository.GetSectionsByChapterID(chapterID);

                // check if result is null or empty
                if (sectionsByChapter == null || !sectionsByChapter.Any())
                {
                    return NotFound($"Error: Sections for chapter {chapterID} could not be found.");
                }

                // Else, return result
                return sectionsByChapter.ToList();
            }

            return NotFound("Error: Invalid chapter ID used. Check that the chapter number is valid (1-14).");
        }



        // GET request that returns the full contents of a section
        [HttpGet("section/{sectionID}/full")]
        public async Task<ActionResult<FullSection>> GetFullSection(int sectionID)
        {
                // check if a valid sectionID is given, 23605 is an ID that is used for section 230A
                if ((sectionID >= 1 && sectionID <= 243) || sectionID == 23065)
                {
                    // get the section's title and content
                    var section = await GetSection(sectionID);

                    // if the section is returned as null or as a default empty object, return a 404
                    if (section == null || section.SectionText == "")
                    {
                        return NotFound($"Error: Section {sectionID} could not be found.");
                    }

                    // if sectionText is null, it means there are subsections
                    if (section.SectionText == null)
                    {
                        // search for subsections of this section
                        IEnumerable<Subsection> subsections = await _mainRepository.GetSubSectionsBySectionID(sectionID);
                        if (subsections.IsNullOrEmpty())
                        {
                            // return if no subsections are found
                            return new FullSection(section.SectionID, section.SectionTitle, section.SectionText, null, null);
                        }

                        IEnumerable<Clause> clauses = [];
                        // for every subsection, check if it contains clauses
                        foreach (var subsection in subsections)
                        {
                            clauses = await _mainRepository.GetClausesOfSubsection(sectionID, subsection.SubsectionID);
                        }

                        // return the section without clauses
                        if (clauses.IsNullOrEmpty())
                        {
                             return new FullSection(section.SectionID, section.SectionTitle, section.SectionText, subsections, null);
                        }

                        // return the full section with subsections and clauses
                        return new FullSection(section.SectionID, section.SectionTitle, section.SectionText, subsections, clauses);
                    }

                    // return FullSection with no subsections or clauses
                    return new FullSection(section.SectionID, section.SectionTitle, section.SectionText, null, null);
                }

                // if the sectionID isn't valid return a 404
                return NotFound("Error: Invalid section ID used. Check that the section number is valid(1-243, 23065 for 230A).");
        } 


        // a function that gets a section's contents by id
        private async Task<Section> GetSection(int sectionID)
        {
                // call getSections() to get all sections in the MainSchema
                IEnumerable<Section> sections = await _mainRepository.GetSections();

                // check if a valid sectionID is given, 23605 is an ID that is used for section 230A
                if ((sectionID >= 1 && sectionID <= 243) || sectionID == 23065)
                {
                    // search through sections
                    return sections.First(section => section.SectionID == sectionID);
                }

                // return an empty object, if no section could be found
                return new Section();
        }



        // GET request that fully returns all sections in a chapter with all content
        [HttpGet("/api/v1/main/chapter/{chapterID}/sections/full")]
        public async Task<ActionResult<FullChapter>> GetFullChapters(int chapterID)
        {
            // Check for a correct ID
           if (chapterID >= 0 && chapterID <= 14)
           {
                // Get the chapter's title
                IEnumerable<Chapter> chapters = await _mainRepository.GetChapters();
                var chapterTitle = chapters.First(chapter => chapter.ChapterID == chapterID).ChapterTitle;

                // Get all section IDs for the chapter
                IEnumerable<SectionByChapter> sectionsByChapter = await _mainRepository.GetSectionsByChapterID(chapterID);

                // if sections aren't found, return 404
                if (sectionsByChapter.IsNullOrEmpty())
                {
                    return NotFound($"Error: sections for chapter {chapterID} could not be found");
                }

                // create and fill list of sections that contain all their content
                List<FullSection> fullSections = [];

                // for every section ID in sectionsByChapter
                foreach (var section in sectionsByChapter)
                {
                    //var fullSection = await HttpGetAttribute("");
                    // if (fullSection != null)
                    // {
                    //     fullSections.Add(fullSection);
                    // }
                }

                // if full sections aren't created, return 404
                if (fullSections.IsNullOrEmpty())
                {
                    return NotFound($"Error: full sections for chapter {chapterID} could not be found.");
                }

                return new FullChapter(chapterID, chapterTitle, fullSections);
           }

            return NotFound("Error: Invalid chapter ID used. Check that the chapter number is valid (1-14).");
        }

         // GET request that returns the Non Derogable Rights table from the Bill of Rights (Chapter 2)
        [HttpGet("ndr/all")]
        public async Task<ActionResult<IEnumerable<NonDerogableRight>>> GetNonDerogableRights()
        {
            // async load the method
            IEnumerable<NonDerogableRight> nonDerogableRights = await _mainRepository.GetNonDerogableRights();

            // check if result is null or empty
            if (nonDerogableRights.IsNullOrEmpty())
            {
                return NotFound("Error: Non derogable rights not found.");
            }

            // Else, return result
            return nonDerogableRights.ToList();
        }
    }
}