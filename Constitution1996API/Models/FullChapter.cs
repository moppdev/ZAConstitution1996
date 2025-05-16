namespace Constitution1996API.Models
{
    // Model for returning a chapter with its id, title and a list of <FullSection> objects
    // which would contain every section
    public class FullChapter
    {
        // fields
        public int ChapterID {get; set;}
        public string ChapterTitle {get; set;} = "N/A";
        public List<FullSection> FullSections {get; set;}= [];

        // constructor that sets the values
        public FullChapter(int chapterID, string title, List<FullSection> fullSections)
        {
            this.ChapterID = chapterID;
            this.ChapterTitle = title;
            this.FullSections = fullSections;
        }
        
    }
}