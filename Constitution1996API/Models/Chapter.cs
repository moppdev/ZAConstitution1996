namespace Constitution1996API.Models
{
    // Model for the response of spGetChapters that returns all chapters' titles and ids
    public class Chapter
    {
        // fields
        public int ChapterID {get; set;}
        public string ChapterTitle {get; set;}

        // constructor to check for nulls
        public Chapter()
        {
            if (ChapterTitle == null)
            {
                ChapterTitle = "N/A";
            }
        }
    }
}