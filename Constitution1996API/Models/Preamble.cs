namespace Constitution1996API.Models
{
    // Model for the response of spGetPreamble, which returns the preamble of the constitution
    public class Preamble
    {
        
        // fields
        public string Title {get; set;} = "Preamble";
        public string PreambleContents {get; set;}


        // constructor that checks for nulls
        public Preamble()
        {
            if (PreambleContents == null)
            {
                PreambleContents = "N/A";
            }
        }
    }
}