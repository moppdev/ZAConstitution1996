namespace Constitution1996API.Models
{
    // Model for the response of spGetAmendments, which returns all amendments made to the constitution
    public class Amendment
    {
        // fields
        public string AmendmentTitle {get; set;}
        public DateTime DateOfEffect {get; set;}
        public string Reference {get; set;}

        // constructor which checks for nulls
        public Amendment()
        {
            if (AmendmentTitle == null)
            {
                AmendmentTitle = "N/A";
            }
            if (Reference == null)
            {
                Reference = "N/A";
            }
        }
    }
}