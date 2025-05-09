namespace Constitution1996API.Models
{
    public class Chapter
    {
        public int ChapterID {get; set;}
        public string ChapterTitle {get; set;}

        public Chapter()
        {
            if (ChapterTitle == null)
            {
                ChapterTitle = "N/A";
            }
        }
    }
}