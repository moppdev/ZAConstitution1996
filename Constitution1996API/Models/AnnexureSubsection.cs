namespace Constitution1996API.Models
{
    // Model for the response of spGetAnnexureSubsections, which returns the subsections, if any, of a section
    public partial class AnnexureSubsection
    {
        // fields
        public string SubsectionID {get; set;} = "N/A";
        public string SectionText {get; set;} = "N/A";
    }
}