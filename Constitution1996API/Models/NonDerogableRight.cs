namespace Constitution1996API.Models
{
    public class NonDerogableRight
    {
        public int SectionNumber {get; set;}        
        public string SectionTitle {get; set;}        
        public string ProtectionExtent {get; set;}

        public NonDerogableRight()
        {
            if (SectionTitle == "N/A")
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