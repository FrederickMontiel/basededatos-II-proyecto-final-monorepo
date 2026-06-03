import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Oportunidad } from './oportunidad.entity';

@Entity('tipo_oportunidad')
export class TipoOportunidad {
  @PrimaryGeneratedColumn()
  id_tipo_oportunidad: number;

  @Column({ length: 50 })
  nombre_tipo: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => Oportunidad, (oportunidad) => oportunidad.tipo)
  oportunidades: Oportunidad[];
}
