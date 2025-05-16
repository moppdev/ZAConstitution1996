namespace Constitution1996API.Models
{
    // Model that holds the result of spGetAnnexures
    // returns an annexure's ID and title
    public class Annexure
    {
        // fields
        public char AnnexureID {get; set;}
        public string AnnexureTitle {get; set;} = "N/A";
    }
}