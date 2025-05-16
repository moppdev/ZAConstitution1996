namespace Constitution1996API.Models
{
    // Model that holds the result of spGetAnnexureSections
    // returns an annexure's ID, section ID, title and text if any
    public class AnnexureSection
    {
        // fields
        public char AnnexureID {get; set;}
        public int SectionID {get; set;}
        public string SectionTitle {get; set;} = "N/A";
        public string? SectionText {get; set;} = null;
    }
}