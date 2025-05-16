namespace Constitution1996API.Models
{
    // Model that returns the results of spGetScheduleFour_ConcurrentCompetencies and spGetScheduleFive_ExclusiveProvincialCompetencies
    // Schedule Four and Five share the same format
    public class Competency
    {
        public string PartID {get; set;} = "N/A";
        public string PartCSV {get; set;} = "N/A";
    }
}