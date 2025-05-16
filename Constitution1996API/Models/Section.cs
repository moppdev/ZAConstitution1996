namespace Constitution1996API.Models
{
      // Model for the response of spGetSections, which returns all sections
    public class Section
    {
        // fields
        public int SectionID {get; set;}
        public int ChapterID {get; set;}
        public string SectionTitle {get; set;} = "N/A";
        public string? SectionText {get; set;} = null;
    }
}