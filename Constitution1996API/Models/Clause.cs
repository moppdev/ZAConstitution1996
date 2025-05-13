namespace Constitution1996API.Models
{
    // Model for the response of spGetClauseOfSubsection
    // that returns clauses of a subsection
    public class Clause
    {
        // fields
        public int SectionID {get; set;} = 0;
        public string SubsectionID {get; set;} = "N/A";
        public string ClauseID {get; set;} = "N/A";
        public string ClauseText {get; set;} = "N/A";
    }
}