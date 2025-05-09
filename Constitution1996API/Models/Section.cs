namespace Constitution1996API.Models
{
    public class Section
    {
        public int SectionID {get; set;}
        public int ChapterID {get; set;}
        public string SectionTitle {get; set;}

        public Section()
        {
            if (SectionTitle == null)
            {
                SectionTitle = "N/A";
            }
        }
    }
}