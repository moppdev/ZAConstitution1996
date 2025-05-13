namespace Constitution1996API.Models
{
    // Model for the response of spGetSubsectionsBySectionID, which returns the subsections, if any, of a section
    public class Subsection
    {
        // fields
        public string SubsectionID {get; set;} = "N/A";
        public string SubsectionText {get; set;} = "N/A";
    }
}