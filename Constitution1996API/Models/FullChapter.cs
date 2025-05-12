namespace Constitution1996API.Models
{
    public class FullChapter
    {
        public int ChapterID {get; set;}
        public string ChapterTitle {get; set;} = "";
        public List<FullSection> FullSections;

        public FullChapter(int chapterID, string title, List<FullSection> fullSections)
        {
            this.ChapterID = chapterID;
            this.ChapterTitle = title;
            this.FullSections = fullSections;
        }
        
    }
}