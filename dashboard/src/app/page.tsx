'use client';

import styles from './page.module.css';
import data from '../data/forest_metrics.json';
import {
  Trees,
  Ruler,
  Weight,
  ArrowRight,
  Activity,
  Layers,
  Search,
  Database
} from 'lucide-react';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  ScatterChart,
  Scatter,
  ZAxis,
  Cell
} from 'recharts';

export default function Home() {
  const { stats, height_distribution, scatter_sample } = data;

  return (
    <main className={styles.container}>
      {/* Hero Section */}
      <section className={styles.hero}>
        <div className={styles.overlay}></div>
        <div className={styles.heroContent}>
          <h1 className="gradient-text">LiDAR Forest Analytics</h1>
          <p>
            An end-to-end research pipeline for estimating 3D Forest Carbon & Biomass
            using high-resolution LiDAR point clouds. Focused on Harvard Forest (NEON).
          </p>
          <div className={styles.cta}>
            <button className={styles.primaryBtn}>Explore Data <ArrowRight size={18} /></button>
            <button className={styles.secondaryBtn}>View R Project</button>
          </div>
        </div>
      </section>

      {/* Stats Summary */}
      <section className={styles.statsGrid}>
        <div className="glass card animate-fade-in" style={{ animationDelay: '0.1s' }}>
          <div className={styles.iconWrapper}><Trees className={styles.icon} /></div>
          <h3>{stats.total_trees.toLocaleString()}</h3>
          <p>Total Trees Identified</p>
        </div>
        <div className="glass card animate-fade-in" style={{ animationDelay: '0.2s' }}>
          <div className={styles.iconWrapper}><Ruler className={styles.icon} /></div>
          <h3>{stats.avg_height}m</h3>
          <p>Average Canopy Height</p>
        </div>
        <div className="glass card animate-fade-in" style={{ animationDelay: '0.3s' }}>
          <div className={styles.iconWrapper}><Weight className={styles.icon} /></div>
          <h3>{stats.total_biomass_mg.toLocaleString()} Mg</h3>
          <p>Total Estimated Biomass</p>
        </div>
        <div className="glass card animate-fade-in" style={{ animationDelay: '0.4s' }}>
          <div className={styles.iconWrapper}><Activity className={styles.icon} /></div>
          <h3>{stats.max_height}m</h3>
          <p>Maximum Tree Height</p>
        </div>
      </section>

      {/* Visualizations */}
      <section className={styles.visuals}>
        <div className="glass chartCard">
          <h2>Tree Height Distribution</h2>
          <div className={styles.chartContainer}>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={height_distribution}>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis dataKey="bin" stroke="#888" />
                <YAxis stroke="#888" />
                <Tooltip
                  contentStyle={{ backgroundColor: '#ffffff', border: 'none', borderRadius: '12px', boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)' }}
                  itemStyle={{ color: '#14532d', fontWeight: 'bold' }}
                  labelStyle={{ color: '#64748b' }}
                />
                <Bar dataKey="count" fill="#2d5a27" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="glass chartCard">
          <h2>Biomass vs. Height Correlation</h2>
          <div className={styles.chartContainer}>
            <ResponsiveContainer width="100%" height={300}>
              <ScatterChart>
                <CartesianGrid strokeDasharray="3 3" stroke="#333" />
                <XAxis type="number" dataKey="MaxHeight_m" name="Height" unit="m" stroke="#888" />
                <YAxis type="number" dataKey="EstBiomass_Mg" name="Biomass" unit="Mg" stroke="#888" />
                <ZAxis type="number" dataKey="CrownArea_m2" range={[20, 200]} name="Crown Area" />
                <Tooltip
                  cursor={{ strokeDasharray: '3 3' }}
                  contentStyle={{ backgroundColor: '#ffffff', border: 'none', borderRadius: '12px', boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)' }}
                  itemStyle={{ color: '#14532d', fontWeight: 'bold' }}
                />
                <Scatter name="Trees" data={scatter_sample} fill="#4ade80" />
              </ScatterChart>
            </ResponsiveContainer>
          </div>
        </div>
      </section>

      {/* Pipeline Logic */}
      <section className={styles.pipeline}>
        <h2 className="gradient-text">The Analytics Pipeline</h2>
        <div className={styles.steps}>
          <div className={styles.step}>
            <div className={styles.stepIcon}><Database /></div>
            <h4>Ingestion</h4>
            <p>Automated fetching of NEON DP1.30003.001 LiDAR tiles.</p>
          </div>
          <div className={styles.step}>
            <div className={styles.stepIcon}><Search /></div>
            <h4>Preprocessing</h4>
            <p>Ground classification using CSF and DTM normalization.</p>
          </div>
          <div className={styles.step}>
            <div className={styles.stepIcon}><Layers /></div>
            <h4>Modeling</h4>
            <p>Pit-free CHM generation using sub-circle aggregation.</p>
          </div>
          <div className={styles.step}>
            <div className={styles.stepIcon}><ArrowRight /></div>
            <h4>Segmentation</h4>
            <p>Dalponte (2016) watershed algorithm for ITS extraction.</p>
          </div>
        </div>
      </section>
    </main>
  );
}
