namespace Constitution1996API.Models
{
    // Models that return the results of spGetScheduleThree_ElectionProcedures, spGetScheduleThree_Parts, spGetScheduleThree_Subsections
    // which returns the contents of Schedule 3
    public class ScheduleThree_Part
    {
        public string PartID {get; set;} = "";
        public string PartName {get; set;} = "";
    }

    public class ScheduleThree_ElectionProcedure
    {
        public int SectionID {get; set;}
        public char SectionThreePart {get; set;}
        public string SectionTitle {get; set;} = "";
        public string? SectionText {get; set;} = null;
    }

    public class ScheduleThree_Subsection
    {
        public int SectionID {get; set;}
        public char SectionThreePart {get; set;}
        public string SubsectionID {get; set;} = "";
        public string SectionText {get; set;} = "";
    }

    // Model that combines the above three to return the entire Schedule's contents
    public class ScheduleThree_Full
    {
        public IEnumerable<ScheduleThree_Part> Parts {get; set;}
        public IEnumerable<ScheduleThree_ElectionProcedure> ElectionProcedures {get; set;}
        public IEnumerable<ScheduleThree_Subsection>? Subsections {get; set;} = null;
        
        // constructor that sets the values
        public ScheduleThree_Full(IEnumerable<ScheduleThree_Part> scheduleThree_Parts, 
        IEnumerable<ScheduleThree_ElectionProcedure> scheduleThree_ElectionProcedures,  IEnumerable<ScheduleThree_Subsection>? subsections)
        {
            this.Subsections = subsections;
            this.ElectionProcedures = scheduleThree_ElectionProcedures;
            this.Parts = scheduleThree_Parts;
        }
    }
}