namespace Constitution1996API.Models
{
    // Model for the response of spGetNonDerogableRights, which returns the contents
    // of the Non Derogable Rights table in Chapter 2, the Bill of Rights
    public class NonDerogableRight
    {
        // fields
        public int SectionNumber {get; set;}        
        public string SectionTitle {get; set;}        
        public string ProtectionExtent {get; set;}

        // Constructor to check for nulls
        public NonDerogableRight()
        {
            if (SectionTitle == null)
            {
                SectionTitle = "N/A";
            }
            if (ProtectionExtent == null)
            {
                ProtectionExtent = "N/A";
            }
        }
    }
}