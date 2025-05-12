namespace Constitution1996API.Models
{
     // Model for the response of spGetSectionsByChapterID, which returns all sections in a chapter
    public class SectionByChapter
    {
        // fields
        public int SectionID {get; set;}
        public string SectionTitle {get; set;}
        public string? SectionText {get; set;}

        // constructor which checks for nulls
        public SectionByChapter()
        {
            if (SectionText == null)
            {
                SectionText = "N/A";
            }
            if (SectionTitle == null)
            {
                SectionTitle = "N/A";
            }
        }
    }
}